Map<String, Object> params = new LinkedHashMap<String, Object>();
            String uniqueRequestId = UUID.randomUUID().toString().substring(0, 12);
            params.put("amount", 10);
            params.put("unique_request_id", uniqueRequestId);
            params.put("order_id", this.order.getOrderId());
            
            RequestOptions requestOptions = RequestOptions.createDefault().withCustomerId(customerId);
            Refund refund = Order.refund(params, requestOptions);
