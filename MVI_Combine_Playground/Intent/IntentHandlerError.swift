enum IntentHandlerError: AppErrorProtocol {
    case invalidError
    
    var errorDescription: String {
        switch self {
        case .invalidError:
            return "정의되지 않은 에러가 발생했습니다. 다시 시도해주세요."
        }
    }
}
