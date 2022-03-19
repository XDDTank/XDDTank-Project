// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//org.aswing.KeyboardManager

package org.aswing
{
    import flash.events.EventDispatcher;
    import org.aswing.util.ASWingVector;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.display.Stage;
    import org.aswing.util.*;

    [Event(name="keyDown", type="flash.events.KeyboardEvent")]
    [Event(name="keyUp", type="flash.events.KeyboardEvent")]
    public class KeyboardManager extends EventDispatcher 
    {

        private static var instance:KeyboardManager;

        private var keymaps:ASWingVector;
        private var keySequence:ASWingVector;
        private var selfKeyMap:KeyMap;
        private var inited:Boolean;
        private var keyJustActed:Boolean;
        public var isStopDispatching:Boolean;
        private var mnemonicModifier:Array;

        public function KeyboardManager()
        {
            this.inited = false;
            this.keyJustActed = false;
            this.keymaps = new ASWingVector();
            this.keySequence = new ASWingVector();
            this.selfKeyMap = new KeyMap();
            this.mnemonicModifier = [Keyboard.CONTROL, Keyboard.SHIFT];
            this.registerKeyMap(this.selfKeyMap);
        }

        public static function getInstance():KeyboardManager
        {
            if (instance == null)
            {
                instance = new (KeyboardManager)();
            };
            return (instance);
        }

        public static function isDown(_arg_1:uint):Boolean
        {
            return (getInstance().isKeyDown(_arg_1));
        }


        public function init(_arg_1:Stage):void
        {
            if ((!(this.inited)))
            {
                this.inited = true;
                _arg_1.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown, false, 0, true);
                _arg_1.addEventListener(KeyboardEvent.KEY_UP, this.__onKeyUp, false, 0, true);
                _arg_1.addEventListener(Event.DEACTIVATE, this.__deactived, false, 0, true);
            };
        }

        override public function dispatchEvent(_arg_1:Event):Boolean
        {
            if (this.isStopDispatching)
            {
                return (false);
            };
            return (super.dispatchEvent(_arg_1));
        }

        public function registerKeyMap(_arg_1:KeyMap):void
        {
            if ((!(this.keymaps.contains(_arg_1))))
            {
                this.keymaps.append(_arg_1);
            };
        }

        public function unregisterKeyMap(_arg_1:KeyMap):void
        {
            this.keymaps.remove(_arg_1);
        }

        public function registerKeyAction(_arg_1:KeyType, _arg_2:Function):void
        {
            this.selfKeyMap.registerKeyAction(_arg_1, _arg_2);
        }

        public function unregisterKeyAction(_arg_1:KeyType, _arg_2:Function):void
        {
            this.selfKeyMap.unregisterKeyAction(_arg_1, _arg_2);
        }

        public function isKeyDown(_arg_1:uint):Boolean
        {
            return (this.keySequence.contains(_arg_1));
        }

        public function setMnemonicModifier(_arg_1:Array):void
        {
            this.mnemonicModifier = _arg_1.concat();
        }

        public function isMnemonicModifierDown():Boolean
        {
            var _local_1:int;
            while (_local_1 < this.mnemonicModifier.length)
            {
                if ((!(this.isKeyDown(this.mnemonicModifier[_local_1]))))
                {
                    return (false);
                };
                _local_1++;
            };
            return (this.mnemonicModifier.length > 0);
        }

        public function isKeyJustActed():Boolean
        {
            return (this.keyJustActed);
        }

        private function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            var _local_5:KeyMap;
            this.dispatchEvent(_arg_1);
            var _local_2:uint = _arg_1.keyCode;
            if (((!(this.keySequence.contains(_local_2))) && (_local_2 < 139)))
            {
                this.keySequence.append(_local_2);
            };
            this.keyJustActed = false;
            var _local_3:int = this.keymaps.size();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = KeyMap(this.keymaps.get(_local_4));
                if (_local_5.fireKeyAction(this.keySequence.toArray()))
                {
                    this.keyJustActed = true;
                };
                _local_4++;
            };
        }

        private function __onKeyUp(_arg_1:KeyboardEvent):void
        {
            this.dispatchEvent(_arg_1);
            var _local_2:uint = _arg_1.keyCode;
            this.keySequence.remove(_local_2);
            if ((!(_arg_1.ctrlKey)))
            {
                this.keySequence.remove(Keyboard.CONTROL);
            };
            if ((!(_arg_1.shiftKey)))
            {
                this.keySequence.remove(Keyboard.SHIFT);
            };
        }

        private function __deactived(_arg_1:Event):void
        {
            this.keySequence.clear();
        }

        public function reset():void
        {
            this.keySequence.clear();
        }


    }
}//package org.aswing

