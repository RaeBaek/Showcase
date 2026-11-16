import React from 'react';
import {FlatList, Image, StyleSheet, Text, View} from 'react-native';

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
    <FlatList
      style={styles.container}
      contentContainerStyle={styles.content}
      contentInsetAdjustmentBehavior="automatic"
      data={movies}
      keyExtractor={movie => String(movie.id)}
      ListHeaderComponent={<Text style={styles.heading}>비슷한 작품</Text>}
      ListEmptyComponent={<Text style={styles.title}>비슷한 작품이 없어요.</Text>}
      renderItem={({item}) => (
        <View style={styles.row}>
          {item.posterURL ? (
            <Image
              source={{uri: item.posterURL}}
              resizeMode="cover"
              style={styles.poster}
            />
          ) : (
            <View style={styles.poster} />
          )}
          <Text style={styles.title}>{item.title || '제목 없음'}</Text>
        </View>
      )}
    />
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#161616',
  },
  content: {
    padding: 20,
    gap: 12,
  },
  heading: {
    color: '#ffffff',
    fontSize: 22,
    fontWeight: '700',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  poster: {
    width: 60,
    height: 90,
    borderRadius: 6,
    backgroundColor: '#303030',
  },
  title: {
    flexShrink: 1,
    color: '#ffffff',
    fontSize: 16,
  },
});
