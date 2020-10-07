create or replace view V_FACT_SALE(
    fact_id,
    product_id,
    product_name,
    sales_order_id,
    manager_id,
    manager_first_name,
    manager_last_name,
    office_id,
    office_name,
    city_id,
    city_name,
    country,
    region,
    sale_qty,
    sale_price,
    sale_amount,
    sale_date
) as
  select ol.ORDER_LINE_ID,
         ol.product_id,
         p.PRODUCT_NAME,
         so.SALES_ORDER_ID,
         so.manager_id,
         m.MANAGER_FIRST_NAME,
         m.MANAGER_LAST_NAME,
         m.office_id,
         o.OFFICE_NAME,
         o.city_id,
         c.CITY_NAME,
         c.COUNTRY,
         c.REGION,
         ol.product_qty,
         ol.product_price,
         ol.product_qty * ol.product_price,
         so.order_date
  from sales_order_line ol
         left outer join sales_order so on (so.sales_order_id = ol.sales_order_id)
         left outer join manager m on (m.manager_id = so.manager_id)
         left outer join office o on (m.office_id = o.office_id)
         left outer join city c on (o.CITY_ID = c.city_id)
         left outer join product p on (p.PRODUCT_ID = ol.PRODUCT_ID);
