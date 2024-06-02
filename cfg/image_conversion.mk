# Paleta de 16 colores. El primer color es el 1 (azul) para que sea el color que se pinte cuando
# la en la memoria de video aparezcan bytes a 0.
PALETTE=1 0 2 10 6 14 11 23 13 22 16 18 19 24 25 26

## Default values
#$(eval $(call IMG2SP, SET_MODE        , 0                  ))  { 0, 1, 2 }
#$(eval $(call IMG2SP, SET_MASK        , none               ))  { interlaced, none }

# Establecer el lugar donde se encuentran los sprites.
$(eval $(call IMG2SP, SET_FOLDER      , src/sprites))

#$(eval $(call IMG2SP, SET_EXTRAPAR    ,                    ))
#$(eval $(call IMG2SP, SET_IMG_FORMAT  , sprites            ))	{ sprites, zgtiles, screen }
#$(eval $(call IMG2SP, SET_OUTPUT      , c                  ))  { bin, c }

# Establecer paleta de colores.
$(eval $(call IMG2SP, SET_PALETTE_FW  , $(PALETTE)))

# Para que la paleta esté disponible en ensamblador.
$(eval $(call IMG2SP, CONVERT_PALETTE , $(PALETTE), g_palette))


######################################################################
# Sprites enemigos
######################################################################
# Sprite de la nave enemiga que tira bombas.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemy-bomber-ship.png , 0, 0, sprite_enemy_bomber_ship))
# Sprite de la nave nave enemiga que no hace nada.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemy-ship.png , 0, 0, sprite_enemy_ship))
# Sprite de la bomba que lanzan los bomber ships.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/bomb.png , 6, 6, sprite_bomb))

######################################################################
# Sprites bloques
######################################################################
# Sprite de un bloque normal (bright cyan).
$(eval $(call IMG2SP, CONVERT         , assets/sprites/block_common.png , 12, 8, sprite_block_common))
# Sprite del bloque de oro.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/block-gold.png , 0, 0, sprite_block_gold))
# Sprite del bloque de plata.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/block-silver.png , 0, 0, sprite_block_silver))


######################################################################
# Sprites borde
######################################################################
# Sprite de la parte superior del borde.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/border-top.png , 0, 0, sprite_border_top))
# Sprite balkan motif
$(eval $(call IMG2SP, CONVERT         , assets/sprites/balkan_motif_left.png , 0, 0, balkan_motif_left))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/balkan_motif_right.png , 0, 0, balkan_motif_right))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/border_motif_left.png , 0, 0, border_motif_left))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/border_motif_right.png , 0, 0, border_motif_right))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/border_side_motif.png , 0, 0, border_side_motif))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/balkan_motif_left_half_size.png , 0, 0, balkan_motif_left_hs))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/balkan_motif_right_half_size.png , 0, 0, balkan_motif_right_hs))

######################################################################
# Strings
######################################################################
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_digits.png , 4, 6, sprite_string_digits))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_lives.png , 0, 0, sprite_string_lives))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_active.png , 0, 0, sprite_string_active))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_power.png , 0, 0, sprite_string_power))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_ups.png , 0, 0, sprite_string_ups))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_score.png , 0, 0, sprite_string_score))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_stage.png , 0, 0, sprite_string_stage))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/string_high.png , 0, 0, sprite_string_high))

######################################################################
# Powerups
######################################################################
$(eval $(call IMG2SP, CONVERT         , assets/sprites/powerup_catch.png , 0, 0, sprite_powerup_catch))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/powerup_extend.png , 0, 0, sprite_powerup_extend))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/powerup_life.png , 0, 0, sprite_powerup_life))

######################################################################
# Sprites misceláneos
######################################################################
# Sprite de la barra que controla el usuario.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/bar.png , 0, 0, sprite_bar))
# Sprite de la pelota.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/ball.png , 0, 0, sprite_ball))
# Sprite de la pelota2.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/ball2.png , 0, 0, sprite_ball2))
# Sprite del icono de vida.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/icon-life.png , 0, 0, sprite_icon_life))
# Sprite del icono de powerup catch.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/icon_powerup_catch.png , 0, 0, sprite_icon_powerup_catch))
# Sprite del icono de powerup extend.
$(eval $(call IMG2SP, CONVERT         , assets/sprites/icon_powerup_extend.png , 0, 0, sprite_icon_powerup_extend))
# Cover
$(eval $(call IMG2SP, CONVERT         , assets/sprites/cover.png , 0, 0, sprite_cover))
# Sprite de game over
$(eval $(call IMG2SP, CONVERT         , assets/sprites/game_over.png , 0, 0, sprite_game_over))
# Sprite de game win
$(eval $(call IMG2SP, CONVERT         , assets/sprites/game_win.png , 0, 0, sprite_game_win))

#$(eval $(call IMG2SP, CONVERT         , img.png , w, h, array, palette, tileset))