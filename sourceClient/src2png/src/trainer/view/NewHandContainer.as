// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//trainer.view.NewHandContainer

package trainer.view
{
    import flash.utils.Dictionary;
    import flash.geom.Point;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.LayerManager;
    import flash.utils.setTimeout;
    import flash.display.DisplayObjectContainer;
    import com.pickgliss.utils.ObjectUtils;

    public class NewHandContainer 
    {

        private static var _instance:NewHandContainer;

        private var _arrows:Dictionary;
        private var _movies:Dictionary;

        public function NewHandContainer(_arg_1:NewHandContainerEnforcer)
        {
            this._arrows = new Dictionary();
            this._movies = new Dictionary();
        }

        public static function get Instance():NewHandContainer
        {
            if ((!(_instance)))
            {
                _instance = new NewHandContainer(new NewHandContainerEnforcer());
            };
            return (_instance);
        }


        public function showArrow(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:String="", _arg_5:Object=null, _arg_6:DisplayObjectContainer=null, _arg_7:int=0):void
        {
            var _local_9:Point;
            var _local_10:MovieClip;
            var _local_11:MovieClip;
            var _local_12:Point;
            if (this.hasArrow(_arg_1))
            {
                this.clearArrow(_arg_1);
            };
            var _local_8:Object = {};
            if ((_arg_3 is Point))
            {
                _local_9 = (_arg_3 as Point);
            }
            else
            {
                _local_9 = ComponentFactory.Instance.creatCustomObject(String(_arg_3));
            };
            _local_10 = ClassUtils.CreatInstance("asset.trainer.TrainerArrowAsset");
            _local_10.mouseChildren = false;
            _local_10.mouseEnabled = false;
            _local_10.rotation = _arg_2;
            _local_10.x = _local_9.x;
            _local_10.y = _local_9.y;
            if (_arg_6)
            {
                _arg_6.addChild(_local_10);
            }
            else
            {
                LayerManager.Instance.addToLayer(_local_10, LayerManager.GAME_UI_LAYER, false, LayerManager.NONE_BLOCKGOUND);
            };
            _local_8["arrow"] = _local_10;
            if (_arg_4 != "")
            {
                _local_11 = ClassUtils.CreatInstance(_arg_4);
                _local_11.mouseChildren = false;
                _local_11.mouseEnabled = false;
                if (_arg_5)
                {
                    if ((_arg_5 is Point))
                    {
                        _local_12 = (_arg_5 as Point);
                    }
                    else
                    {
                        _local_12 = ComponentFactory.Instance.creatCustomObject(String(_arg_5));
                    };
                    _local_11.x = _local_12.x;
                    _local_11.y = _local_12.y;
                };
                if (_arg_6)
                {
                    _arg_6.addChild(_local_11);
                }
                else
                {
                    LayerManager.Instance.addToLayer(_local_11, LayerManager.GAME_UI_LAYER, false, LayerManager.NONE_BLOCKGOUND);
                };
                _local_8["tip"] = _local_11;
            };
            this._arrows[_arg_1] = _local_8;
            if (_arg_7 > 0)
            {
                setTimeout(this.clearArrow, _arg_7, _arg_1);
            };
        }

        public function clearArrowByID(_arg_1:int):void
        {
            var _local_2:String;
            if (_arg_1 == -1)
            {
                for (_local_2 in this._arrows)
                {
                    this.clearArrow(int(_local_2));
                };
            }
            else
            {
                this.clearArrow(_arg_1);
            };
        }

        public function hasArrow(_arg_1:int):Boolean
        {
            return (!(this._arrows[_arg_1] == null));
        }

        public function showMovie(_arg_1:String, _arg_2:String=""):void
        {
            var _local_4:Point;
            if (this._movies[_arg_1])
            {
                throw (new Error("Already has a arrow with this id!"));
            };
            var _local_3:MovieClip = ClassUtils.CreatInstance(_arg_1);
            _local_3.mouseEnabled = (_local_3.mouseChildren = false);
            if (_arg_2 != "")
            {
                _local_4 = ComponentFactory.Instance.creatCustomObject(_arg_2);
                _local_3.x = _local_4.x;
                _local_3.y = _local_4.y;
            };
            LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_DYNAMIC_LAYER, false, LayerManager.NONE_BLOCKGOUND);
            this._movies[_arg_1] = _local_3;
        }

        public function hideMovie(_arg_1:String):void
        {
            var _local_2:String;
            if (_arg_1 == "-1")
            {
                for (_local_2 in this._movies)
                {
                    this.clearMovie(_local_2);
                };
            }
            else
            {
                this.clearMovie(_arg_1);
            };
        }

        private function clearArrow(_arg_1:int):void
        {
            var _local_2:Object = this._arrows[_arg_1];
            if (_local_2)
            {
                ObjectUtils.disposeObject(_local_2["arrow"]);
                ObjectUtils.disposeObject(_local_2["tip"]);
            };
            delete this._arrows[_arg_1];
        }

        private function clearMovie(_arg_1:String):void
        {
            ObjectUtils.disposeObject(this._movies[_arg_1]);
            delete this._movies[_arg_1];
        }

        public function dispose():void
        {
            _instance = null;
            this._arrows = null;
            this._movies = null;
        }


    }
}//package trainer.view

class NewHandContainerEnforcer 
{


}


