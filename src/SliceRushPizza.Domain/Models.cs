namespace SliceRushPizza.Domain;

public record Payment(string PaymentNumber, PaymentStatus PaymentStatus, Order Order);
public record Order(string OrderNumber, List<OrderLine> OrderLines);
public record OrderLine(Pizza Pizza, int Amount);
public record Pizza(string PizzaId, string Name);

public enum PaymentStatus
{
    Pending,
    Paid,
    Failed
}