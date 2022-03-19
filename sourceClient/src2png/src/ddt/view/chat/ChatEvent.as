// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatEvent

package ddt.view.chat
{
    import flash.events.Event;

    public class ChatEvent extends Event 
    {

        public static const ADD_CHAT:String = "addChat";
        public static const CAN_SHOW_BUGGLE:String = "canShowBuggle";
        public static const CUSTOM_SET_PRIVATE_CHAT_TO:String = "customSetPrivateChatTo";
        public static const INPUT_CHANNEL_CHANNGED:String = "inputChannelChanged";
        public static const INPUT_TEXT_CHANGED:String = "inputTextChanged";
        public static const NICKNAME_CLICK_TO_OUTSIDE:String = "nicknameClickToOutside";
        public static const SCROLL_CHANG:String = "scrollChanged";
        public static const SHOW_FACE:String = "addFace";
        public static const DELETE:String = "delete";
        public static const SEND_CONSORTIA:String = "sendConsortia";
        public static const SET_FACECONTIANER_LOCTION:String = "setFacecontainerLoction";
        public static const BUTTON_SHINE:String = "buttonShine";

        public var data:Object;

        public function ChatEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this.data = _arg_2;
        }

        override public function clone():Event
        {
            return (new ChatEvent(type, this.data));
        }


    }
}//package ddt.view.chat

