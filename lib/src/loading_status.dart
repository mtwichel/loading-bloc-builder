/// A status of loading some data, usually by an api call
enum LoadingStatus {
  /// No call has been made
  initial,

  /// The call has been made and we are awaiting results
  loading,

  /// The call has returned and was successful
  success,

  /// The call has returned with an error
  failure,
}
