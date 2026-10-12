abstract class TransportationStates {}
class InitialTransportationState extends TransportationStates {}
class getPostsLoadingState extends TransportationStates {}

class getAllCompaniesSuccessState extends TransportationStates {}
class getAllCompaniesErrorState extends TransportationStates {}

class AllState extends TransportationStates {}
class getSearchState extends TransportationStates {}
class isSearchState extends TransportationStates {}


class addFavState extends TransportationStates {}
class removedFromFavSuccess extends TransportationStates {}
class removedFromFavError extends TransportationStates {}


class postCommentLoadingState extends TransportationStates {}
class postCommentSuccessState extends TransportationStates {}
class postCommentErrorState extends TransportationStates {}

class deleteCommentLoadingState extends TransportationStates {}
class deleteCommentSuccessState extends TransportationStates {}
class deleteCommentErrorState extends TransportationStates {}

class putCommentLoadingState extends TransportationStates {}
class putCommentSuccessState extends TransportationStates {}
class putCommentErrorState extends TransportationStates {}

class getAllComentsSuccessState extends TransportationStates {}
class getAllComentsErrorState extends TransportationStates {}
class getAllComentsLoadingState extends TransportationStates {}
class checkCommendUserIdState extends TransportationStates{}