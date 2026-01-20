import React from 'react'
import { View, Text, Button, ScrollView } from 'react-native'

export default function Homescreen({navigation}) {
    return (
        <ScrollView
            contentInsetAdjustmentBehavior="automatic"
            contentContainerStyle={{alignItems: 'center', justifyContent: 'space-around', height: "100%"}}
        >
            <Text>Juspay Integration Example</Text>
            <Button onPress={() => navigation.navigate('Checkout')} style={{backgroundColor:"blue", width:"40%", height: 30, borderRadius:5, alignItems: "center", justifyContent: "center"}} title="Checkout"></Button>
        </ScrollView>
    )
}
