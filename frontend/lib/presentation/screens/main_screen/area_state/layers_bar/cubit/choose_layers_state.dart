enum ChooseLayerState {lands, capitals, organizations, sanitaries, starts, buildings}

class ChooseLayersState {
  ChooseLayersState(this.state);
  Set<ChooseLayerState> state;
}