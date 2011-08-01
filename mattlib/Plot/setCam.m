% set the current camera view to one
%   previously recorded by getCam
%
% CAMDOLLY Dolly camera.
% CAMERAMENU  Interactively manipulate camera.
% CAMERATOOLBAR  Interactively manipulate camera.
% CAMLOOKAT Move camera and target to view specified objects.
% CAMORBIT Orbit camera.
% CAMPAN Pan camera.
% CAMPOS Camera position.
% CAMPROJ Camera projection.
% CAMROLL Roll camera.
% CAMROTATE Camera rotation utility function.
% CAMTARGET Camera target.
% CAMUP Camera up vector.
% CAMVA Camera view angle.
% CAMZOOM Zoom camera.
% CAMPOSM Camera position from geographic coordinates
% CAMTARGM Camera target from geographic coordinates
% CAMUPM Camera UpVector from geographic coordinates
%
% setCam(cam);

function setCam(cam)

  campos(cam.CameraPosition);
  camtarget(cam.CameraTarget);
  camup(cam.CameraUpVector);
  camva(cam.CameraViewAngle);

  %cam.CameraPositionMode = get(gca, 'CameraPositionMode');
  %cam.CameraTargetMode = get(gca, 'CameraTargetMode');
  %cam.CameraUpVectorMode = get(gca, 'CameraUpVectorMode');
  %cam.CameraViewAngleMode = get(gca, 'CameraViewAngleMode');
