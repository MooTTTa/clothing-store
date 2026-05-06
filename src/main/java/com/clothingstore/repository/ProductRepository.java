package com.clothingstore.repository;

import com.clothingstore.model.Category;
import com.clothingstore.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByActiveTrue();
    List<Product> findByCategoryAndActiveTrue(Category category);
    List<Product> findByNameContainingIgnoreCaseAndActiveTrue(String name);
}
