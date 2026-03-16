abstract class FranchiseModelEvent {}

class FetchFranchiseModel extends FranchiseModelEvent {
  final String serviceId;

  FetchFranchiseModel(this.serviceId);
}
