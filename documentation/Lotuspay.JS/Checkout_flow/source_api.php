<?php

$responseData = request();
header('Content-type:application/json;charset=utf-8');
header('Access-Control-Allow-Origin: *');
echo $responseData;

function request() {
    $url = "https://api-test.lotuspay.com/v1/sources";
    // $returnUrl= "https://www.themerchantreturnUrl.com";
    $mandate_details =$_POST["mandate_details"];
    $bank_data =$_POST["bank_data"];
    error_log(print_r($_POST, TRUE));

    $nach_debit;
    $redirect;

    $nach_debit["amount_maximum"]=$mandate_details["amount_max"];
    $nach_debit["date_first_collection"]=$mandate_details["date_first_collection"];
    $nach_debit["frequency"]=$mandate_details["frequency"];

    $nach_debit["creditor_utility_code"]=$mandate_details["creditor_utility_code"];
    $nach_debit["creditor_agent_code"]=$mandate_details["creditor_agent_code"];


    $nach_debit["debtor_agent_code"]=$bank_data["ifsc"];   
    $nach_debit["debtor_account_name"]=$bank_data["debtor_account_name"];
    $nach_debit["debtor_account_number"]=$bank_data["debtor_account_number"];
    $nach_debit["debtor_account_type"]=$bank_data["debtor_account_type"];
    $redirect["return_url"]="https://www.lotuspay.com";
    $merchantkey = "sk_test_yGwM9BTxoXOp1wLl7QphSew3";
    $type="nach_debit";


    $data["nach_debit"]=$nach_debit;
    $data["redirect"]= $redirect;
    $data["type"]= $type;

    $final_payload = http_build_query($data);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_USERPWD, $merchantkey.":");
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $final_payload);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);// this should be set to true in production
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $responseData = curl_exec($ch);
    error_log(print_r($responseData, TRUE));
    if(curl_errno($ch)) {
        return curl_error($ch);
    }
    curl_close($ch);
    return $responseData;
}
?>