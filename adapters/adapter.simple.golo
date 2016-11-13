module adapter.simple

augmentation botFeatures = {
  function yo = |this| -> println("yo!")
}

augment bots.types.indyBot with botFeatures
