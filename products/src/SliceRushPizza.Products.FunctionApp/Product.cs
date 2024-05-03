using System;
using Azure;
using Azure.Data.Tables;

namespace SliceRushPizza.Products.FunctionApp;

public class Product : ITableEntity
{
    public string PartitionKey { get; set; }
    public string RowKey { get; set; }
    public DateTimeOffset? Timestamp { get; set; }
    public ETag ETag { get; set; }

    public string Name { get; set; }
    public decimal Price { get; set; }
}

// public class OfficeSupplyEntity : ITableEntity
// {
//     public string Product { get; set; }
//     public double Price { get; set; }
//     public int Quantity { get; set; }
//     public string PartitionKey { get; set; }
//     public string RowKey { get; set; }
//     public DateTimeOffset? Timestamp { get; set; }
//     public ETag ETag { get; set; }
// }