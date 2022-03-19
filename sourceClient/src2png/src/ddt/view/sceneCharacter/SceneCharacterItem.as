// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterItem

package ddt.view.sceneCharacter
{
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import flash.geom.Point;

    public class SceneCharacterItem 
    {

        private var _type:String;
        private var _groupType:String;
        private var _sortOrder:int;
        private var _source:BitmapData;
        private var _points:Vector.<Point>;
        private var _cellWitdh:Number;
        private var _cellHeight:Number;
        private var _rowNumber:int;
        private var _rowCellNumber:int;
        private var _isRepeat:Boolean;
        private var _repeatNumber:int;

        public function SceneCharacterItem(_arg_1:String, _arg_2:String, _arg_3:BitmapData, _arg_4:int, _arg_5:int, _arg_6:Number, _arg_7:Number, _arg_8:int=0, _arg_9:Vector.<Point>=null, _arg_10:Boolean=false, _arg_11:int=0)
        {
            this._type = _arg_1;
            this._groupType = _arg_2;
            this._source = _arg_3;
            this._rowNumber = _arg_4;
            this._rowCellNumber = _arg_5;
            this._cellWitdh = _arg_6;
            this._cellHeight = _arg_7;
            this._points = _arg_9;
            this._sortOrder = _arg_8;
            this._isRepeat = _arg_10;
            this._repeatNumber = _arg_11;
        }

        public function get type():String
        {
            return (this._type);
        }

        public function get groupType():String
        {
            return (this._groupType);
        }

        public function get source():BitmapData
        {
            return (this._source);
        }

        public function set source(_arg_1:BitmapData):void
        {
            this._source = _arg_1;
        }

        public function get points():Vector.<Point>
        {
            return (this._points);
        }

        public function get cellWitdh():Number
        {
            return (this._cellWitdh);
        }

        public function get cellHeight():Number
        {
            return (this._cellHeight);
        }

        public function get rowNumber():int
        {
            return (this._rowNumber);
        }

        public function set rowNumber(_arg_1:int):void
        {
            this._rowNumber = _arg_1;
        }

        public function get rowCellNumber():int
        {
            return (this._rowCellNumber);
        }

        public function set rowCellNumber(_arg_1:int):void
        {
            this._rowCellNumber = _arg_1;
        }

        public function get sortOrder():int
        {
            return (this._sortOrder);
        }

        public function get isRepeat():Boolean
        {
            return (this._isRepeat);
        }

        public function get repeatNumber():int
        {
            return (this._repeatNumber);
        }

        public function dispose():void
        {
            if (this._source)
            {
                this._source.dispose();
            };
            this._source = null;
            while (((this._points) && (this._points.length > 0)))
            {
                this._points.shift();
            };
            this._points = null;
        }


    }
}//package ddt.view.sceneCharacter

