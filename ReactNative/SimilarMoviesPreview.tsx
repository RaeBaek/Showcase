import React from 'react';
import {StyleSheet, Text, View} from 'react-native';

type SimilarMovie = {
  id: number;
  title: string | null;
  posterURL: string | null;
};

type Props = {
  movies: SimilarMovie[];
};

export default function SimilarMoviesPreview({movies}: Props) {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>React Native</Text>
      <Text style={styles.summary}>전달받은 작품 {movies.length}개</Text>
      {movies[0]?.title ? (
        <Text style={styles.summary}>{movies[0].title}</Text>
      ) : null}
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
  summary: {
    color: '#ffffff',
    marginTop: 8,
  },
});
