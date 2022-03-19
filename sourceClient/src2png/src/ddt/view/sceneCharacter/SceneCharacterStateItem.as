// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterStateItem

package ddt.view.sceneCharacter
{
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;

    public class SceneCharacterStateItem 
    {

        private var _type:String;
        private var _sceneCharacterSet:SceneCharacterSet;
        private var _sceneCharacterActionSet:SceneCharacterActionSet;
        private var _sceneCharacterSynthesis:SceneCharacterSynthesis;
        private var _sceneCharacterBase:SceneCharacterBase;
        private var _frameBitmap:Vector.<Bitmap>;
        private var _sceneCharacterActionItem:SceneCharacterActionItem;
        private var _sceneCharacterDirection:SceneCharacterDirection;

        public function SceneCharacterStateItem(_arg_1:String, _arg_2:SceneCharacterSet, _arg_3:SceneCharacterActionSet)
        {
            this._type = _arg_1;
            this._sceneCharacterSet = _arg_2;
            this._sceneCharacterActionSet = _arg_3;
        }

        public function update():void
        {
            if (((!(this._sceneCharacterSet)) || (!(this._sceneCharacterActionSet))))
            {
                return;
            };
            if (this._sceneCharacterSynthesis)
            {
                this._sceneCharacterSynthesis.dispose();
            };
            this._sceneCharacterSynthesis = null;
            this._sceneCharacterSynthesis = new SceneCharacterSynthesis(this._sceneCharacterSet, this.sceneCharacterSynthesisCallBack);
        }

        private function sceneCharacterSynthesisCallBack(_arg_1:Vector.<Bitmap>):void
        {
            this._frameBitmap = _arg_1;
            if (this._sceneCharacterBase)
            {
                this._sceneCharacterBase.dispose();
            };
            this._sceneCharacterBase = null;
            this._sceneCharacterBase = new SceneCharacterBase(this._frameBitmap);
            this._sceneCharacterBase.sceneCharacterActionItem = (this._sceneCharacterActionItem = this._sceneCharacterActionSet.dataSet[0]);
        }

        public function set setSceneCharacterActionType(_arg_1:String):void
        {
            var _local_2:SceneCharacterActionItem = this._sceneCharacterActionSet.getItem(_arg_1);
            if (_local_2)
            {
                this._sceneCharacterActionItem = _local_2;
            };
            this._sceneCharacterBase.sceneCharacterActionItem = this._sceneCharacterActionItem;
        }

        public function get setSceneCharacterActionType():String
        {
            return (this._sceneCharacterActionItem.type);
        }

        public function set sceneCharacterDirection(_arg_1:SceneCharacterDirection):void
        {
            if (this._sceneCharacterDirection == _arg_1)
            {
                return;
            };
            this._sceneCharacterDirection = _arg_1;
        }

        public function get type():String
        {
            return (this._type);
        }

        public function set type(_arg_1:String):void
        {
            this._type = _arg_1;
        }

        public function get sceneCharacterSet():SceneCharacterSet
        {
            return (this._sceneCharacterSet);
        }

        public function set sceneCharacterSet(_arg_1:SceneCharacterSet):void
        {
            this._sceneCharacterSet = _arg_1;
        }

        public function get sceneCharacterBase():SceneCharacterBase
        {
            return (this._sceneCharacterBase);
        }

        public function dispose():void
        {
            if (this._sceneCharacterSet)
            {
                this._sceneCharacterSet.dispose();
            };
            this._sceneCharacterSet = null;
            if (this._sceneCharacterActionSet)
            {
                this._sceneCharacterActionSet.dispose();
            };
            this._sceneCharacterActionSet = null;
            if (this._sceneCharacterSynthesis)
            {
                this._sceneCharacterSynthesis.dispose();
            };
            this._sceneCharacterSynthesis = null;
            if (this._sceneCharacterBase)
            {
                this._sceneCharacterBase.dispose();
            };
            this._sceneCharacterBase = null;
            if (this._sceneCharacterActionItem)
            {
                this._sceneCharacterActionItem.dispose();
            };
            this._sceneCharacterActionItem = null;
            this._sceneCharacterDirection = null;
            while (((this._frameBitmap) && (this._frameBitmap.length > 0)))
            {
                this._frameBitmap[0].bitmapData.dispose();
                this._frameBitmap[0].bitmapData = null;
                this._frameBitmap.shift();
            };
            this._frameBitmap = null;
        }


    }
}//package ddt.view.sceneCharacter

