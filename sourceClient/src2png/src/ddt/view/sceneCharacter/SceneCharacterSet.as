// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterSet

package ddt.view.sceneCharacter
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class SceneCharacterSet 
    {

        private var _dataSet:Vector.<SceneCharacterItem>;

        public function SceneCharacterSet()
        {
            this._dataSet = new Vector.<SceneCharacterItem>();
        }

        public function push(_arg_1:SceneCharacterItem):void
        {
            this._dataSet.push(_arg_1);
        }

        public function get length():uint
        {
            return (this._dataSet.length);
        }

        public function get dataSet():Vector.<SceneCharacterItem>
        {
            return (this._dataSet.sort(this.sortOn));
        }

        private function sortOn(_arg_1:SceneCharacterItem, _arg_2:SceneCharacterItem):Number
        {
            if (_arg_1.sortOrder < _arg_2.sortOrder)
            {
                return (-1);
            };
            if (_arg_1.sortOrder > _arg_2.sortOrder)
            {
                return (1);
            };
            return (0);
        }

        public function dispose():void
        {
            while (((this._dataSet) && (this._dataSet.length > 0)))
            {
                this._dataSet[0].dispose();
                this._dataSet.shift();
            };
            this._dataSet = null;
        }


    }
}//package ddt.view.sceneCharacter

