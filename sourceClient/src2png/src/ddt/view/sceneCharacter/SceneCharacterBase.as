// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterBase

package ddt.view.sceneCharacter
{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;

    public class SceneCharacterBase extends Sprite 
    {

        private var _frameBitmap:Vector.<Bitmap>;
        private var _sceneCharacterActionItem:SceneCharacterActionItem;
        private var _frameIndex:int = (Math.random() * 7);

        public function SceneCharacterBase(_arg_1:Vector.<Bitmap>)
        {
            this._frameBitmap = _arg_1;
            this.initialize();
        }

        private function initialize():void
        {
        }

        public function update():void
        {
            if (this._frameIndex < this._sceneCharacterActionItem.frames.length)
            {
                this.loadFrame(this._sceneCharacterActionItem.frames[this._frameIndex++]);
            }
            else
            {
                if (this._sceneCharacterActionItem.repeat)
                {
                    this._frameIndex = 0;
                };
            };
        }

        private function loadFrame(_arg_1:int):void
        {
            if (_arg_1 >= this._frameBitmap.length)
            {
                _arg_1 = (this._frameBitmap.length - 1);
            };
            if (((this._frameBitmap) && (this._frameBitmap[_arg_1])))
            {
                if (((this.numChildren > 0) && (this.getChildAt(0))))
                {
                    removeChildAt(0);
                };
                addChild(this._frameBitmap[_arg_1]);
            };
        }

        public function set sceneCharacterActionItem(_arg_1:SceneCharacterActionItem):void
        {
            this._sceneCharacterActionItem = _arg_1;
            this._frameIndex = 0;
        }

        public function get sceneCharacterActionItem():SceneCharacterActionItem
        {
            return (this._sceneCharacterActionItem);
        }

        public function dispose():void
        {
            while (numChildren > 0)
            {
                removeChildAt(0);
            };
            while (((this._frameBitmap) && (this._frameBitmap.length > 0)))
            {
                this._frameBitmap[0].bitmapData.dispose();
                this._frameBitmap[0].bitmapData = null;
                this._frameBitmap.shift();
            };
            this._frameBitmap = null;
            if (this._sceneCharacterActionItem)
            {
                this._sceneCharacterActionItem.dispose();
            };
            this._sceneCharacterActionItem = null;
        }


    }
}//package ddt.view.sceneCharacter

