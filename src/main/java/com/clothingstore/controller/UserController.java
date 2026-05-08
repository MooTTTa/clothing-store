package com.clothingstore.controller;

import com.clothingstore.model.User;
import com.clothingstore.service.CartService;
import com.clothingstore.service.OrderService;
import com.clothingstore.service.ProductService;
import com.clothingstore.service.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final OrderService orderService;
    private final ProductService productService;
    private final CartService cartService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/register")
    public String registerPage(Model model, HttpSession session) {
        model.addAttribute("user", new User());
        model.addAttribute("cartCount", cartService.getItemCount(session));
        return "register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            userService.register(user);
            redirectAttributes.addFlashAttribute("success", "Cadastro realizado! Faça login.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }
    }

    @GetMapping("/orders")
    public String orders(Authentication authentication, Model model, HttpSession session) {
        User user = userService.findByEmail(authentication.getName());
        model.addAttribute("orders", orderService.getUserOrders(user));
        model.addAttribute("cartCount", cartService.getItemCount(session));
        model.addAttribute("categories", productService.getAllCategories());
        return "orders";
    }

    @GetMapping("/checkout")
    public String checkout(Model model, HttpSession session) {
        model.addAttribute("items", cartService.getItems(session));
        model.addAttribute("total", cartService.getTotal(session));
        model.addAttribute("cartCount", cartService.getItemCount(session));
        model.addAttribute("categories", productService.getAllCategories());
        return "checkout";
    }

    @PostMapping("/checkout")
    public String processCheckout(@RequestParam String cep,
                                  @RequestParam String rua,
                                  @RequestParam String numero,
                                  @RequestParam(required = false, defaultValue = "") String complemento,
                                  @RequestParam String bairro,
                                  @RequestParam String cidade,
                                  @RequestParam String estado,
                                  Authentication authentication,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        try {
            String enderecoCompleto = rua + ", " + numero
                    + (complemento.isBlank() ? "" : ", " + complemento)
                    + " - " + bairro + ", " + cidade + " - " + estado
                    + ", CEP: " + cep;

            User user = userService.findByEmail(authentication.getName());
            orderService.createOrder(user, enderecoCompleto, session);
            redirectAttributes.addFlashAttribute("success", "Pedido realizado com sucesso!");
            return "redirect:/orders";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/checkout";
        }
    }
}
