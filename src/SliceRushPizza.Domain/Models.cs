namespace SliceRushPizza.Domain;

public record Payment(string PaymentNumber, PaymentStatus PaymentStatus, Order Order);

public record Order(string OrderNumber, List<OrderLine> OrderLines)
{
    public decimal OrderTotal => OrderLines.Sum(line => line.LinePrice);
}

public record OrderLine(Pizza Pizza, int Amount)
{
    public decimal LinePrice => Pizza.Price * Amount;
}

public record Pizza(string PizzaId, string Name, decimal Price);

public enum PaymentStatus
{
    Pending,
    Paid,
    Failed
}