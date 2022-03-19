// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.loader.TrainerLoader

package ddt.loader
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;

    public class TrainerLoader extends EventDispatcher implements Disposeable 
    {

        private var _module:String;
        private var _loadCompleted:Boolean;

        public function TrainerLoader(_arg_1:String)
        {
            this._module = (UIModuleTypes.TRAINER + _arg_1);
        }

        public function get completed():Boolean
        {
            return (this._loadCompleted);
        }

        public function load():void
        {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleLoader.Instance.addUIModuleImp(this._module);
        }

        private function __onUIModuleComplete(_arg_1:UIModuleEvent):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            if (_arg_1.module == this._module)
            {
                this._loadCompleted = true;
            };
        }

        public function dispose():void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
        }


    }
}//package ddt.loader

