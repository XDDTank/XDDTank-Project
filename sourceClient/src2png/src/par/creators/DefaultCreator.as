// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.creators.DefaultCreator

package par.creators
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;

    public class DefaultCreator implements IParticalCreator 
    {


        public function createPartical():DisplayObject
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0);
            _local_1.graphics.drawCircle(0, 0, 10);
            _local_1.graphics.endFill();
            return (_local_1);
        }


    }
}//package par.creators

