//
//  L10n.swift
//  Localization
//
//  Created by 백래훈 on 11/06/25.
//

import Foundation

public enum L10n {
    public static var current: String {
        let locale = Locale.current.identifier

        if locale.starts(with: "ko") {
            return "ko-KR"
        } else if locale.starts(with: "en") {
            return "en-US"
        } else if locale.starts(with: "ja") {
            return "ja-JP"
        } else {
            return "ko-KR"
        }
    }

    public static func tr(_ key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }

    public enum Home {
        public static var title: String { L10n.tr("home_title") }
        public static var sectionMovies: String { L10n.tr("home_section_movies") }
        public static var sectionPeople: String { L10n.tr("home_section_people") }
        public static var sectionTvs: String { L10n.tr("home_section_tvs") }
    }

    public enum MovieTVDetail {
        public static var detailPlay: String { L10n.tr("detail_play") }
        public static var detailMyList: String { L10n.tr("detail_my_list") }
        public static var detailEvaluation: String { L10n.tr("detail_evaluation") }
        public static var detailShare: String { L10n.tr("detail_share") }
        public static var detailOverview: String { L10n.tr("detail_overview") }
        public static var detailNoOverview: String { L10n.tr("detail_no_overview") }
        public static var detailProduction: String { L10n.tr("detail_production") }
        public static var detailVideo: String { L10n.tr("detail_video") }
        public static var detailSimilarPiece: String { L10n.tr("detail_similar_piece") }
    }

    public enum MovieDetail {
        public static var detailMinute: String { L10n.tr("movie_detail_minute") }
    }

    public enum TVDetail {
        public static var detailSeason: String { L10n.tr("tv_detail_season") }
        public static var detailEpisode: String { L10n.tr("tv_detail_episode") }
    }

    public enum PeopleDetail {
        public static var detailInfo: String { L10n.tr("people_detail_info") }
        public static var detailBorn: String { L10n.tr("people_detail_born") }
        public static var detailDied: String { L10n.tr("people_detail_died") }
        public static var detailBirthplace: String { L10n.tr("people_detail_birthplace") }
        public static var detailWebsite: String { L10n.tr("people_detail_website") }
        public static var detailBiography: String { L10n.tr("people_detail_biography") }
        public static var detailNoBiography: String { L10n.tr("people_detail_no_biography") }
        public static var detailOtherPiece: String { L10n.tr("people_detail_other_piece") }
    }

    public enum Error {
        public static var errorRetry: String { L10n.tr("error_retry") }
        public static var networkError: String { L10n.tr("network_error") }
    }

    public enum Common {
        public static var commonMore: String { L10n.tr("common_more") }
        public static var commonLess: String { L10n.tr("common_less") }
    }
}
