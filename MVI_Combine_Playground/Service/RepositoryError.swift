enum RepositoryError: AppErrorProtocol {
    case requestFailed

    var errorDescription: String {
        return "네트워크 요청에 실패했어요. 다시 시도해주세요!"
    }
}
