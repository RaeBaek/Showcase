import React from 'react';
import {StyleSheet, Text, View} from 'react-native';

export default function SimilarMoviesPreview() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>React Native</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#161616',
  },
  title: {
    color: '#ffffff',
    fontSize: 22,
  },
});
