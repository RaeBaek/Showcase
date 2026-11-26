import React, {useEffect, useRef, useState} from 'react';
import {
  ActivityIndicator,
  FlatList,
  Image,
  NativeModules,
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';

type SimilarMovie = {
  id: number;
  title: string | null;
  originalTitle: string | null;
  posterURL: string | null;
};

type Props = {
  movies: SimilarMovie[];
  page: number;
  totalPages: number;
  hasMore: boolean;
  requestID: string;
};

type NextPageResult =
  | {status: 'loaded'; movies: SimilarMovie[]; page: number; hasMore: boolean}
  | {status: 'end' | 'inactive' | 'busy' | 'failed'; hasMore: boolean};

type LoadStatus = 'idle' | 'loading' | 'failed' | 'continue';

export default function SimilarMoviesPreview(props: Props) {
  return <SimilarMoviesList key={props.requestID} {...props} />;
}

function SimilarMoviesList({movies, hasMore, requestID}: Props) {
  const [items, setItems] = useState(movies);
  const [loadStatus, setLoadStatus] = useState<LoadStatus>('idle');
  const pagination = useRef<{hasMore: boolean; status: LoadStatus}>({
    hasMore,
    status: 'idle',
  });
  const isMounted = useRef(true);
  const reportedRequestID = useRef<string | null>(null);

  useEffect(() => {
    isMounted.current = true;
    return () => {
      isMounted.current = false;
    };
  }, []);

  const updateLoadStatus = (status: LoadStatus) => {
    pagination.current.status = status;
    setLoadStatus(status);
  };

  const loadNextPage = async () => {
    if (
      !pagination.current.hasMore ||
      pagination.current.status === 'loading'
    ) {
      return;
    }

    updateLoadStatus('loading');

    try {
      const result: NextPageResult =
        await NativeModules.SimilarMoviesNavigation.loadNextPage(requestID);
      if (!isMounted.current) {
        return;
      }

      pagination.current.hasMore = result.hasMore;
      if (result.status === 'loaded' && result.movies.length > 0) {
        setItems(currentItems => [...currentItems, ...result.movies]);
        updateLoadStatus('idle');
      } else if (result.status === 'failed') {
        updateLoadStatus('failed');
      } else {
        updateLoadStatus(result.hasMore ? 'continue' : 'idle');
      }
    } catch {
      if (isMounted.current) {
        updateLoadStatus('failed');
      }
    }
  };

  const loadMoreAtEnd = () => {
    if (pagination.current.status === 'idle') {
      void loadNextPage();
    }
  };

  const reportFirstRowLayout = () => {
    if (reportedRequestID.current === requestID) {
      return;
    }

    reportedRequestID.current = requestID;
    NativeModules.SimilarMoviesNavigation?.reportFirstRowLayout?.(requestID);
  };

  return (
    <FlatList
      style={styles.container}
      contentContainerStyle={styles.content}
      contentInsetAdjustmentBehavior="automatic"
      data={items}
      keyExtractor={movie => String(movie.id)}
      onEndReached={loadMoreAtEnd}
      onEndReachedThreshold={0.5}
      ListHeaderComponent={<Text style={styles.heading}>비슷한 작품</Text>}
      ListEmptyComponent={<Text style={styles.title}>비슷한 작품이 없어요.</Text>}
      ListFooterComponent={
        loadStatus === 'loading' ? (
          <ActivityIndicator
            accessibilityLabel="비슷한 작품 불러오는 중"
            color="#ffffff"
            style={styles.footer}
          />
        ) : loadStatus === 'failed' || loadStatus === 'continue' ? (
          <View style={styles.footer}>
            {loadStatus === 'failed' ? (
              <Text style={styles.originalTitle}>작품을 더 불러오지 못했어요.</Text>
            ) : null}
            <Pressable
              accessibilityRole="button"
              onPress={() => {
                void loadNextPage();
              }}
              style={styles.footerButton}>
              <Text style={styles.title}>
                {loadStatus === 'failed' ? '다시 시도' : '더 불러오기'}
              </Text>
            </Pressable>
          </View>
        ) : null
      }
      renderItem={({item, index}) => (
        <Pressable
          accessibilityRole="button"
          onLayout={index === 0 ? reportFirstRowLayout : undefined}
          onPress={() =>
            NativeModules.SimilarMoviesNavigation.selectMovie(
              String(item.id),
              requestID,
            )
          }
          style={styles.row}>
          {item.posterURL ? (
            <Image
              source={{uri: item.posterURL}}
              resizeMode="cover"
              style={styles.poster}
            />
          ) : (
            <View style={styles.poster} />
          )}
          <View style={styles.titles}>
            <Text style={styles.title}>{item.title || '제목 없음'}</Text>
            {item.originalTitle?.trim() ? (
              <Text style={styles.originalTitle}>{item.originalTitle}</Text>
            ) : null}
          </View>
        </Pressable>
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
  footer: {
    alignItems: 'center',
    gap: 8,
    paddingVertical: 12,
  },
  footerButton: {
    padding: 12,
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
  titles: {
    flex: 1,
    gap: 4,
  },
  originalTitle: {
    color: '#aaaaaa',
    fontSize: 14,
  },
  title: {
    flexShrink: 1,
    color: '#ffffff',
    fontSize: 16,
  },
});
