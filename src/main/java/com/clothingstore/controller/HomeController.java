package com.clothingstore.controller;

import com.clothingstore.service.CartService;
import com.clothingstore.service.ProductService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final ProductService productService;
    private final CartService cartService;

    @GetMapping("/")
    public String home(Model model, HttpSession session) {
        model.addAttribute("products", productService.getAllActiveProducts());
        model.addAttribute("categories", productService.getAllCategories());
        model.addAttribute("cartCount", cartService.getItemCount(session));
        return "index";
    }

    @GetMapping("/products")
    public String products(
            @RequestParam(required = false) Long category,
            @RequestParam(required = false) String search,
            Model model, HttpSession session) {

        if (search != null && !search.isBlank()) {
            model.addAttribute("products", productService.searchProducts(search));
            model.addAttribute("search", search);
        } else if (category != null) {
            model.addAttribute("products", productService.getProductsByCategory(category));
            model.addAttribute("selectedCategory", category);
        } else {
            model.addAttribute("products", productService.getAllActiveProducts());
        }

        model.addAttribute("categories", productService.getAllCategories());
        model.addAttribute("cartCount", cartService.getItemCount(session));
        return "products";
    }
}
