package com.clothingstore.config;

import com.clothingstore.model.*;
import com.clothingstore.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import java.math.BigDecimal;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (categoryRepository.count() > 0) return;

        Category camisetas = new Category();
        camisetas.setName("Camisetas");
        camisetas.setDescription("Camisetas masculinas e femininas");
        categoryRepository.save(camisetas);

        Category calcas = new Category();
        calcas.setName("Calças");
        calcas.setDescription("Calças jeans, sociais e casuais");
        categoryRepository.save(calcas);

        Category vestidos = new Category();
        vestidos.setName("Vestidos");
        vestidos.setDescription("Vestidos casuais e sociais");
        categoryRepository.save(vestidos);

        Category acessorios = new Category();
        acessorios.setName("Acessórios");
        acessorios.setDescription("Cintos, bolsas e mais");
        categoryRepository.save(acessorios);

        saveProduct("Camiseta Básica Branca", "Camiseta de algodão premium, corte clássico", "49.90", 50, camisetas);
        saveProduct("Camiseta Estampada Verão", "Camiseta com estampa exclusiva da coleção verão", "69.90", 30, camisetas);
        saveProduct("Camiseta Polo", "Polo masculina slim fit, várias cores", "89.90", 25, camisetas);
        saveProduct("Calça Jeans Slim", "Calça jeans corte slim com stretch para maior conforto", "149.90", 20, calcas);
        saveProduct("Calça Social Preta", "Calça social masculina, tecido premium", "199.90", 15, calcas);
        saveProduct("Vestido Floral Midi", "Vestido midi com estampa floral, ideal para o verão", "129.90", 18, vestidos);
        saveProduct("Vestido Casual Azul", "Vestido casual manga curta, confortável e elegante", "109.90", 22, vestidos);

        if (!userRepository.existsByEmail("admin@modastore.com")) {
            User admin = new User();
            admin.setName("Administrador");
            admin.setEmail("admin@modastore.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRole(Role.ADMIN);
            userRepository.save(admin);
        }
    }

    private void saveProduct(String name, String desc, String price, int stock, Category cat) {
        Product p = new Product();
        p.setName(name);
        p.setDescription(desc);
        p.setPrice(new BigDecimal(price));
        p.setStock(stock);
        p.setCategory(cat);
        productRepository.save(p);
    }
}
