// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.RichesButton

package bagAndInfo.bag
{
    import com.pickgliss.ui.core.TransformableComponent;
    import flash.display.Graphics;

    public class RichesButton extends TransformableComponent 
    {


        override public function draw():void
        {
            this.drawBackground();
            super.draw();
        }

        private function drawBackground():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.beginFill(0xFFFFFF, 0);
            _local_1.drawRect(0, 0, ((_width <= 0) ? 1 : _width), ((_height <= 0) ? 1 : _height));
            _local_1.endFill();
        }


    }
}//package bagAndInfo.bag

