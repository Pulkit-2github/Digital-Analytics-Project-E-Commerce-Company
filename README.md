# Digital-Analytics-Project-E-Commerce-Company (Selling Stuffed Animal Toys)
<img width="744" height="460" alt="image" src="https://github.com/user-attachments/assets/bf76b494-4096-45e2-a89f-544a5b865b5f" />

## BUSINESS CONTEXT/PROBLEM:
The client is a newly launched e-commerce retail startup that sells stuffed animal toys. 

## THE SITUATION: 
Cindy is CEO of an e-commerce company and is planning to secure next round of funding, she needs the analytics team’s help to tell a compelling story to investors. Therefore, the client wants dashboards for different stakeholders 
which helps in tracking business metrics and KPIs regularly, so that the stakeholders can make data-driven decisions to improve the company’s performance.
In addition to this, the Analytics team needs to provide a detailed analysis of company performance and new product analysis.

As part of the project, I was responsible to work with below stakeholders:
• Cindy Sharp – CEO
• Morgan Rockwell – Website Manager
• Tom Parmesan – Marketing Director

## DATA AVAILABILITY:
This project utilizes a custom-built e-commerce database. 
The database contains six related tables with eCommerce data about:
• Website Activity
• Products
• Orders
<img width="917" height="644" alt="image" src="https://github.com/user-attachments/assets/fd9f8535-3070-4a37-bbbf-611d0de78bea" />

## DATA DESCRIPTION:
### Orders Database:
1. Orders :
Records consist of customers' orders with order id, time when the order is created, website session id, unique user id, 
product id, count of products purchased, price (revenue), and cost in USD.

2. Order_items :
Records show various items ordered by customer with order item id, when the order is created, whether it is primary or non
primary item, product info, individual product price, and cost in USD.

3. order_item_refunds : Refund information including when creation date and time and refund amount in USD.

### Website Database:
1. website_sessions : Table is showing where the traffic is coming from and which source is helping to generate the 
orders. Records consist of unique website session id, UTM (Urchin Tracking Module) fields. UTMs tracking parameters 
used by Google Analytics to track paid marketing activity.

2. website_pageviews: It consists of website session id, pageview URL.

### Products Database:
1. Products : It consists of product id, creation date of product in system, and product name.

## BUSINESS OBJECTIVE:
<img width="1231" height="623" alt="image" src="https://github.com/user-attachments/assets/d34eab1a-1884-4b71-8ecb-5e0544944582" />


## POWER BI DASHBOARDS:
[3 POWER BI DASHBOARDS] (https://drive.google.com/file/d/1bhhKFfARWTQ_yKmZY7XmnUVWJ9-sYMX0/view?usp=drive_link)

## TECHNOLOGY STACK USED:
### 1. MS EXCEL 
      For Preliminary Data Auditing & Chart Creation
      Reason : User-friendly interface with powerful functions for quick analysis and basic charts.

### 2. MICROSOFT SQL SERVER
      For Data extraction, Transformation and Analysis
      Reason : Efficient data retrieval and management, supporting complex queries and maintaining data integrity.

### 3. MICROSOFT POWER BI
      For Dashboard Preparation
      Reason : Advanced visualization capabilities and seamless integration with various data sources for dynamic reporting.
