
package com.mall.controller.admin;

import com.mall.common.ServiceResultEnum;
import com.mall.entity.AdminUser;
import com.mall.service.AdminUserService;
import com.mall.dao.MallOrderMapper;
import com.mall.dao.MallGoodsMapper;
import com.mall.dao.MallUserMapper;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Resource
    private AdminUserService adminUserService;
    @Resource
    private MallOrderMapper mallOrderMapper;
    @Resource
    private MallGoodsMapper mallGoodsMapper;
    @Resource
    private MallUserMapper mallUserMapper;

    @GetMapping({"/login"})
    public String login() {
        return "admin/login";
    }

    @GetMapping({"/test"})
    public String test() {
        return "admin/test";
    }


    @GetMapping({"", "/", "/index", "/index.html"})
    public String index(HttpServletRequest request) {
        request.setAttribute("path", "index");
        return "admin/index";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpServletRequest request) {
        request.setAttribute("path", "index");
        try {
            double totalSales = mallOrderMapper.getTotalSales();
            int totalOrders = mallOrderMapper.countByStatus(0) + mallOrderMapper.countByStatus(1) + mallOrderMapper.countByStatus(2);
            int pendingOrders = mallOrderMapper.countByStatus(0);
            int totalGoods = mallGoodsMapper.getTotalStock();
            int totalUsers = 0;
            try {
                java.util.HashMap<String, Object> userParams = new java.util.HashMap<>();
                userParams.put("page", "1");
                userParams.put("limit", "1");
                totalUsers = mallUserMapper.getTotalMallUsers(new com.mall.util.PageQueryUtil(userParams));
            } catch (Exception ignored) {}

            List<Map<String, Object>> monthlySales = mallOrderMapper.getMonthlySales();
            List<Map<String, Object>> topGoods = mallGoodsMapper.getTopGoods(10);

            request.setAttribute("totalSales", totalSales);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("totalGoods", totalGoods);
            request.setAttribute("totalUsers", totalUsers);

            List<String> months = new ArrayList<>();
            List<Double> amounts = new ArrayList<>();
            List<Integer> counts = new ArrayList<>();
            for (Map<String, Object> m : monthlySales) {
                months.add(0, (String) m.get("month"));
                amounts.add(0, ((Number) m.get("total")).doubleValue());
                counts.add(0, ((Number) m.get("count")).intValue());
            }
            ObjectMapper om = new ObjectMapper();
            request.setAttribute("monthsData", om.writeValueAsString(months));
            request.setAttribute("amountsData", om.writeValueAsString(amounts));
            request.setAttribute("countsData", om.writeValueAsString(counts));

            List<String> goodsNames = new ArrayList<>();
            List<Integer> goodsStocks = new ArrayList<>();
            for (Map<String, Object> g : topGoods) {
                goodsNames.add((String) g.get("name"));
                goodsStocks.add(((Number) g.get("stock")).intValue());
            }
            request.setAttribute("topGoods", topGoods);
            request.setAttribute("goodsNames", om.writeValueAsString(goodsNames));
            request.setAttribute("goodsStocks", om.writeValueAsString(goodsStocks));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "admin/dashboard";
    }

    @PostMapping(value = "/login")
    public String login(@RequestParam("userName") String userName,
                        @RequestParam("password") String password,
                        @RequestParam(value = "verifyCode", required = false) String verifyCode,
                        HttpSession session) {
        if (StringUtils.isEmpty(userName) || StringUtils.isEmpty(password)) {
            session.setAttribute("errorMsg", "用户名或密码不能为空");
            return "admin/login";
        }
        AdminUser adminUser = adminUserService.login(userName, password);
        if (adminUser != null) {
            session.setAttribute("loginUser", adminUser.getNickName());
            session.setAttribute("loginUserId", adminUser.getAdminUserId());
            //session过期时间设置为7200秒 即两小时
            //session.setMaxInactiveInterval(60 * 60 * 2);
            return "redirect:/admin/index";
        } else {
            session.setAttribute("errorMsg", "登录失败");
            return "admin/login";
        }
    }

    @GetMapping("/profile")
    public String profile(HttpServletRequest request) {
        Integer loginUserId = (int) request.getSession().getAttribute("loginUserId");
        AdminUser adminUser = adminUserService.getUserDetailById(loginUserId);
        if (adminUser == null) {
            return "admin/login";
        }
        request.setAttribute("path", "profile");
        request.setAttribute("loginUserName", adminUser.getLoginUserName());
        request.setAttribute("nickName", adminUser.getNickName());
        return "admin/profile";
    }

    @PostMapping("/profile/password")
    @ResponseBody
    public String passwordUpdate(HttpServletRequest request, @RequestParam("originalPassword") String originalPassword,
                                 @RequestParam("newPassword") String newPassword) {
        if (StringUtils.isEmpty(originalPassword) || StringUtils.isEmpty(newPassword)) {
            return "参数不能为空";
        }
        Integer loginUserId = (int) request.getSession().getAttribute("loginUserId");
        if (adminUserService.updatePassword(loginUserId, originalPassword, newPassword)) {
            //修改成功后清空session中的数据，前端控制跳转至登录页
            request.getSession().removeAttribute("loginUserId");
            request.getSession().removeAttribute("loginUser");
            request.getSession().removeAttribute("errorMsg");
            return ServiceResultEnum.SUCCESS.getResult();
        } else {
            return "修改失败";
        }
    }

    @PostMapping("/profile/name")
    @ResponseBody
    public String nameUpdate(HttpServletRequest request, @RequestParam("loginUserName") String loginUserName,
                             @RequestParam("nickName") String nickName) {
        if (StringUtils.isEmpty(loginUserName) || StringUtils.isEmpty(nickName)) {
            return "参数不能为空";
        }
        Integer loginUserId = (int) request.getSession().getAttribute("loginUserId");
        if (adminUserService.updateName(loginUserId, loginUserName, nickName)) {
            return ServiceResultEnum.SUCCESS.getResult();
        } else {
            return "修改失败";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().removeAttribute("loginUserId");
        request.getSession().removeAttribute("loginUser");
        request.getSession().removeAttribute("errorMsg");
        return "admin/login";
    }
}
