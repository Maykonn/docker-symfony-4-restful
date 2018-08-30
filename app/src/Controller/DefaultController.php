<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Entity\User;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;

class DefaultController extends AbstractController
{
    public function register(Request $request, UserPasswordEncoderInterface $encoder): JsonResponse
    {
        $input = json_decode($request->getContent());

        $user = new User($input->username);
        $user->setPassword($encoder->encodePassword($user, $input->password));

        $em = $this->getDoctrine()->getManager();
        $em->persist($user);
        $em->flush();

        $response = new JsonResponse();
        $response->setData([
            'message' => sprintf('User %s successfully created', $user->getUsername())
        ]);

        return $response;
    }

    public function api(): JsonResponse
    {
        $response = new JsonResponse();
        $response->setData([
            'message' => sprintf('Logged in as %s', $this->getUser()->getUsername())
        ]);

        return $response;
    }
}
