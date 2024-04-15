using HotChocolate.Subscriptions;

namespace SliceRushPizza.Api;

public class Mutation
{
    public async Task<OrderDto> PlaceOrder(OrderDto order, [Service] ITopicEventSender topicEventSender)
    {
        await topicEventSender.SendAsync("Order Placed", order);
        return order;
    }
}