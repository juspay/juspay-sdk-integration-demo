Map<String, Object> params = new LinkedHashMap<>();
            params.put("amount", amount);
            params.put("unique_request_id", uniqueRequestId);
            params.put("order_id", orderId);

            RequestOptions requestOptions = RequestOptions.createDefault();

            Order refund = Order.refund(orderId, params, requestOptions);
            String jsonResponse = objectMapper.writeValueAsString(refund);
