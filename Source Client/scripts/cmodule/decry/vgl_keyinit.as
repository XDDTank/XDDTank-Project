package cmodule.decry
{
   public function vgl_keyinit(param1:int) : int
   {
      trace("vgl_keymode: " + param1);
      vglKeyMode = param1;
      return 0;
   }
}
