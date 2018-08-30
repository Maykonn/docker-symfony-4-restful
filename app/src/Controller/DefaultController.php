<?php

namespace App\Controller;

use FOS\RestBundle\View\View;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Entity\User;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;

class DefaultController extends AbstractController
{
    public function register(Request $request, UserPasswordEncoderInterface $encoder)
    {
        $user = new User($request->get('username'));
        $user->setPassword($encoder->encodePassword($user, $request->get('password')));

        $em = $this->getDoctrine()->getManager();
        $em->persist($user);
        $em->flush();

        return View::create($user, Response::HTTP_CREATED, []);
    }

    public function api()
    {
        $data = ['isLogged' => sprintf('Logged in as %s', $this->getUser()->getUsername())];
        return View::create($data, Response::HTTP_OK);
    }
}
