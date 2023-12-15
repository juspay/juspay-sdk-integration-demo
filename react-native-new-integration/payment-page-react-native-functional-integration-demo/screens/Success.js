import React from 'react'
import { View, Text } from 'react-native'

export default function Success() {
    return (
        <View style={{display: "flex", height:"100%", alignItems: "center", justifyContent: "center"}}>
            <Text style={{color: "green", fontSize:30}}>Success :D</Text>
        </View>
    )
}
