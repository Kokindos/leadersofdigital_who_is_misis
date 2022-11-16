abstract class ShowContextMenuState {

}

class ClosedShowContextMenuState extends ShowContextMenuState{}

class OpenShowContextMenuState extends ShowContextMenuState {
  final double x, y;

  OpenShowContextMenuState(this.x, this.y);
}