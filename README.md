# Caso de Estudo — Amazonas (E-commerce)

## Integrantes do Grupo
Priscilla Cavalcanti de Almeida

---

## Contexto
A empresa Amazonas, do ramo de e-commerce, deseja acompanhar o fluxo de cliques de seus clientes e rastrear os produtos comprados.  
Atualmente vende: livros, CDs e pequenos eletrodomesticos de cozinha, mas ha expectativa de expansao para outros produtos futuramente.

## Perguntas dos exercicios:
1. Qual e a media de produtos comprados por cliente?  
2. Quais sao os 20 produtos mais populares por estado dos clientes?  
3. Qual e o valor medio das vendas por estado do cliente?  
4. Quantos de cada tipo de produto foram vendidos nos ultimos 30 dias?  

---

## Decisao de Modelagem
Optei por utilizar multiplas colecoes no MongoDB, ao inves de uma unica, devido a:
- **Separacao de responsabilidades**: clientes, produtos, pedidos e eventos de cliques possuem ciclos de vida e volume diferentes.  
- **Performance**: evita documentos muito grandes e facilita consultas especificas.  
- **Evolucao**: possibilita inclusao de novas categorias de produto sem quebrar o modelo.  

## As colecoes sao:
- `customer` - informacoes de clientes (inclui estado/UF).  
- `products` - catalogo de produtos, com campos comuns e `detalhes de categoria` para dados especificos de cada tipo.  
- `orders` pedidos realizados, com snapshot de valores e estado do cliente.  
- `clickstream` eventos de navegacao e interacao (page_view, product_view, add_to_cart, purchase).  

---

## Estrutura dos Documentos

### customer
```json
{
  "customer_id": "CUST-000123",
  "name": "Maria Souza",
  "email": "maria@example.com",
  "state": "SP",
  "created_at": { "$date": "2024-11-10T15:22:03Z" }
}
```

### products
```json
{
  "product_id": "PROD-BOOK-001",
  "name": "Clean Architecture",
  "category": "book",
  "price": 129.90,
  "brand": "Prentice Hall",
  "active": true,
  "category_details": {
    "isbn": "9780134494166",
    "author": "Robert C. Martin",
    "pages": 432,
    "language": "pt-BR"
  }
}
```

### orders
```json
{
  "order_id": "ORD-2025-000987",
  "customer_id": "CUST-000123",
  "customer_state": "SP",
  "order_date": { "$date": "2025-09-10T13:05:45Z" },
  "items": [
    {
      "product_id": "PROD-BOOK-001",
      "category": "book",
      "unit_price": 129.90,
      "quantity": 1,
      "line_total": 129.90
    }
  ],
  "order_total": 129.90,
  "payment_method": "credit_card",
  "status": "paid"
}
```

### clickstream
```json
{
  "event_id": "EVT-000101",
  "customer_id": "CUST-000123",
  "type": "product_view",
  "timestamp": { "$date": "2025-09-15T18:42:11Z" },
  "context": { "session_id": "SESS-xyz789", "device": "desktop" },
  "product": { "product_id": "PROD-BOOK-001", "category": "book" }
}
```

---

## Pergunta 2
**Quais sao os 20 produtos mais populares por estado dos clientes?**

db.orders.insertOne({
  order_id: "ORD-2025-000987",
  customer_id: "CUST-000123",
  customer_state: "SP",
  order_date: ISODate("2025-09-10T13:05:45Z"),
  items: [
    {
      product_id: "PROD-BOOK-001",
      category: "book",
      unit_price: 129.90,
      quantity: 1,
      line_total: 129.90
    }
  ],
  order_total: 129.90,
  payment_method: "credit_card",
  status: "paid"
})

---

## Estrutura do Repositório
```
impacta-labs/
 └── README.md
     ├── collection_customers.json
     ├── collection_products.json
     ├── collection_orders.json
     ├── collection_clickstream.json
     └── command_mongo.sh     
```

---

## Conclusão
Este projeto visa atender às necessidades da **Amazonas** no acompanhamento de vendas e comportamento dos clientes, oferecendo modelagem escalável, consultas eficientes e preparando o ambiente para expansão futura de categorias de produtos.
