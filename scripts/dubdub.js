    function shake_xy(n) {
    if (self.moveBy) {
        for (i = 10; i > 0; i--) {
            for (j = n; j > 0; j--) {
            self.moveBy(0,i);
            self.moveBy(i,0);
            self.moveBy(0,-i);
            self.moveBy(-i,0);
            }
          }
       }
    }
    function shake_x(n) {
    if (self.moveBy) {
        for (i = 10; i > 0; i--) {
            for (j = n; j > 0; j--) {
            self.moveBy(i,0);
            self.moveBy(-i,0);
            }
          }
       }
    }
    function shake_y(n) {
    if (self.moveBy) {
        for (i = 10; i > 0; i--) {
            for (j = n; j > 0; j--) {
            self.moveBy(0,i);
            self.moveBy(0,-i);
            }
          }
       }
    }
    //-->