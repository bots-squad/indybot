module adapter.simple

augmentation botSimpleFeatures = {
  function yo = |this| -> println("yo!")
}

augment bots.types.indyBot with botSimpleFeatures
