#!/usr/bin/env bash
# Script para rodar consulta no MongoDB
# Retorna os 20 produtos mais populares por estado

mongosh <<'EOF'
use amazonas_db;

db.orders.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: { state: "$customer_state", product_id: "$items.product_id" },
      qty_sold: { $sum: "$items.quantity" }
    }
  },
  {
    $lookup: {
      from: "products",
      localField: "_id.product_id",
      foreignField: "product_id",
      as: "prod"
    }
  },
  { $unwind: "$prod" },
  { $sort: { "_id.state": 1, "qty_sold": -1 } },
  {
    $group: {
      _id: "$_id.state",
      top_products: {
        $push: {
          product_id: "$_id.product_id",
          name: "$prod.name",
          category: "$prod.category",
          qty_sold: "$qty_sold"
        }
      }
    }
  },
  {
    $project: {
      _id: 0,
      state: "$_id",
      top_20: { $slice: ["$top_products", 20] }
    }
  }
]).pretty();
EOF
