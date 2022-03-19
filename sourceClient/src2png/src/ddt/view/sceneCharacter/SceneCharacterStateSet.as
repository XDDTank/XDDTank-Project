// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterStateSet

package ddt.view.sceneCharacter
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class SceneCharacterStateSet 
    {

        private var _dataSet:Vector.<SceneCharacterStateItem>;

        public function SceneCharacterStateSet()
        {
            this._dataSet = new Vector.<SceneCharacterStateItem>();
        }

        public function push(_arg_1:SceneCharacterStateItem):void
        {
            if ((!(_arg_1)))
            {
                return;
            };
            _arg_1.update();
            this._dataSet.push(_arg_1);
        }

        public function get length():uint
        {
            return (this._dataSet.length);
        }

        public function get dataSet():Vector.<SceneCharacterStateItem>
        {
            return (this._dataSet);
        }

        public function getItem(_arg_1:String):SceneCharacterStateItem
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

