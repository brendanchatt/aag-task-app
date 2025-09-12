enum TaskStatusFilter {
  all('All'),
  active('Active'),
  completed('Completed');

  const TaskStatusFilter(this.displayName);
  final String displayName;
}
