using SliceRushPizza.Domain;

namespace SliceRushPizza.Api;

public class Subscription
{
    [Subscribe]
    [Topic("Order Placed")]

    public OrderDto OnOrderPlaced([EventMessage] OrderDto order)
    {
        return order;
    }
}