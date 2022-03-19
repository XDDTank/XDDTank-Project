// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.ThumbnailTip

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import flash.geom.Point;

    public class ThumbnailTip extends Sprite 
    {


        public function show():void
        {
            var _local_1:Point;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            if (((stage) && (parent)))
            {
                _local_1 = parent.globalToLocal(new Point(stage.mouseX, stage.mouseY));
                this.x = (_local_1.x + 15);
                this.y = (_local_1.y + 15);
                if ((x + 182) > 1000)
                {
                    this.x = (x - 182);
                };
                if ((y + 234) > 600)
                {
                    y = (600 - 234);
                };
            };
        }


    }
}//package game.view.playerThumbnail

