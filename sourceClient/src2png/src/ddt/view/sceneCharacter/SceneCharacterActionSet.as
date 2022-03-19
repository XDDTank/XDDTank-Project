// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterActionSet

package ddt.view.sceneCharacter
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class SceneCharacterActionSet 
    {

        private var _dataSet:Vector.<SceneCharacterActionItem>;

        public function SceneCharacterActionSet()
        {
            this._dataSet = new Vector.<SceneCharacterActionItem>();
        }

        public function push(_arg_1:SceneCharacterActionItem):void
        {
            this._dataSet.push(_arg_1);
        }

        public function get length():uint
        {
            return (this._dataSet.length);
        }

        public function get dataSet():Vector.<SceneCharacterActionItem>
        {
            return (this._dataSet);
        }

        public function getItem(_arg_1:String):SceneCharacterActionItem
        {
            var _local_2:int;
            if (((this._dataSet) && (this._dataSet.length > 0)))
            {
                _local_2 = 0;
                while (_local_2 < this._dataSet.length)
                {
                    if (this._dataSet[_local_2].type == _arg_1)
                    {
                        return (this._dataSet[_local_2]);
                    };
                    _local_2++;
                };
            };
            return (null);
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

