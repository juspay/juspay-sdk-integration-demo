import React from 'react'
import { View, Text } from 'react-native'

export default function Failure() {
    return (
        <View style={{display: "flex", height: "100%", alignItems: "center", justifyContent: "center"}}>
            <Text style={{color: "red", fontSize:30}}>Failure :(</Text>
        </View>
    )
}
