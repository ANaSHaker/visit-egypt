abstract class EventsStates {}
class InitialEventsState extends EventsStates {}
class loadingEventsState extends EventsStates {}

class getEventSuccessState extends EventsStates {}
class getEventsErrorState extends EventsStates {}

class getImageSuccessState extends EventsStates {}
class getImageErrorState extends EventsStates {}

class chanegValue extends EventsStates {}


class addFavState extends EventsStates {}
class removedFromFavSuccess extends EventsStates {}
class removedFromFavError extends EventsStates {}

class postCommentLoadingState extends EventsStates {}
class postCommentSuccessState extends EventsStates {}
class postCommentErrorState extends EventsStates {}

class deleteCommentLoadingState extends EventsStates {}
class deleteCommentSuccessState extends EventsStates {}
class deleteCommentErrorState extends EventsStates {}

class putCommentLoadingState extends EventsStates {}
class putCommentSuccessState extends EventsStates {}
class putCommentErrorState extends EventsStates {}

class getAllComentsSuccessState extends EventsStates {}
class getAllComentsErrorState extends EventsStates {}
class getAllComentsLoadingState extends EventsStates {}
class checkCommendUserIdState extends EventsStates{}

class saveStartState extends EventsStates{}
class saveEndState extends EventsStates{}

class sendEventSuccess extends EventsStates {}
class sendEventLoading extends EventsStates{}
class sendEventError extends EventsStates{}

class getCategorieEventsSuccessState extends EventsStates {}
class getCategorieEventsErrorState extends EventsStates {}
class getCategorieEventsLoadingState extends EventsStates {}

class changeValSuccessState extends EventsStates {}

class getImageStateS extends EventsStates {}
